terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
    }
  }
}

resource "helm_release" "this" {
  name      = var.helm_chart_release_name
  namespace = var.namespace

  repository = var.helm_chart_repo
  chart      = var.helm_chart_name
  version    = var.helm_chart_version

  values = [
    yamlencode(
      merge(
        {
          rbac           = { create = true }
          serviceAccount = {
            create      = true
            name        = "external-dns"
            annotations = {
              "eks.amazonaws.com/role-arn" = aws_iam_role.this.arn
            }
          }
          provider      = "aws"
          domainFilters = [var.zone_name]
          extraArgs : [
            "--aws-zone-type=public",
            "--aws-batch-change-size=1000",
          ]
          serviceMonitor = { enabled = false }

          sources = [
            "service",
            "ingress",
          ]
        },
        var.settings,
      )
    )
  ]
}

resource "aws_iam_role" "this" {
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

resource "aws_iam_role_policy" "this" {
  name_prefix = var.name
  role        = aws_iam_role.this.id
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
