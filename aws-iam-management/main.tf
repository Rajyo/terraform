terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-1"
}

locals {
  users_data = yamldecode(file("./users.yaml")).users
  user_role_pair = flatten([for user in local.users_data : [for role in user.roles : {
    username = user.username
    role     = role
  }]])
}

output "output" {
  value = local.user_role_pair
}


# Creating Users
resource "aws_iam_user" "main" {
  for_each = toset(local.users_data[*].username)
  name     = each.value
}

# Password creation
resource "aws_iam_user_login_profile" "profile" {
  for_each        = aws_iam_user.main
  user            = each.value.name
  password_length = 12

  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
      pgp_key
    ]
  }
}

# Policy Attachment
resource "aws_iam_user_policy_attachment" "policy" {
    for_each = {
      for pair in local.user_role_pair: "${pair.username}-${pair.role}" => pair
    }
    user = aws_iam_user.main[each.value.username].name
    policy_arn = "arn:aws:iam::aws:policy/${each.value.role}"
}
