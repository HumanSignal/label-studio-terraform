terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
    }
  }
}

resource "helm_release" "cert_manager" {
  name      = var.helm_chart_release_name
  namespace = var.namespace

  repository = var.helm_chart_repo
  chart      = var.helm_chart_name
  version    = var.helm_chart_version

  values = [
    jsonencode({
      installCRDs    = true,
      serviceAccount = {
        annotations = {
          "eks.amazonaws.com/role-arn" = aws_iam_role.cert_manager.arn
        }
      }
    }),
    jsonencode(var.helm_values),
  ]
}

resource "kubectl_manifest" "letsencrypt_cluster_issuer" {
  yaml_body = yamlencode({
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata   = {
      name = "letsencrypt-cluster-issuer"
    }
    spec = {
      acme = {
        email               = var.email
        privateKeySecretRef = {
          name : "letsencrypt-private-key"
        }
        server  = "https://acme-v02.api.letsencrypt.org/directory"
        solvers = [
          {
            dns01 = {
              route53 = {
                region       = var.region
                hostedZoneID = var.zone_id
              }
            }
          },
        ]
      }
    }
  })

  depends_on = [
    helm_release.cert_manager,
  ]
}

resource "kubectl_manifest" "certificate" {
  yaml_body = yamlencode({
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"
    metadata   = {
      name      = "${var.name}-certificate"
      namespace = var.namespace
    }
    spec = {
      dnsNames = [
        var.zone_name,
        "*.${var.zone_name}",
      ]
      secretName = var.tls_secret_name
      issuerRef  = {
        kind = "ClusterIssuer"
        name = kubectl_manifest.letsencrypt_cluster_issuer.name
      }
    }
  })

  depends_on = [
    aws_iam_role.cert_manager,
  ]
}

resource "aws_iam_role" "cert_manager" {
  name_prefix        = var.name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "${var.oidc_provider_arn}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "oidc.eks.${var.region}.amazonaws.com/id/${regex("[A-Z0-9]{32}", var.oidc_provider_arn)}:aud": "sts.amazonaws.com"
        }
      }
    }
  ]
}
EOF
}

#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_role_policy" "cert_manager" {
  name_prefix = var.name
  role        = aws_iam_role.cert_manager.id
  policy      = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "route53:GetChange",
        "Resource" : "arn:aws:route53:::change/*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets"
        ],
        "Resource" : [
          "arn:aws:route53:::hostedzone/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "route53:ListHostedZones"
        ],
        "Resource" : ["*"]
      },
      {
        "Effect" : "Allow",
        "Action" : "route53:ListHostedZonesByName",
        "Resource" : "*"
      }
    ]
  })
}
