provider "aws" {
  region     = "eu-west-1"
  access_key = var.access_key
  secret_key = var.secret_key
}
provider "github" {
  token = var.token
}

resource "github_repository" "whole_site" {
  name        = "whole_site"
  description = "Repository for content editor"

  visibility = "public"
}

resource "github_repository" "github-repo-1" {
  name        = "marketing"
  description = "Repository for Alice & Malory"

  visibility = "public"
}

resource "github_repository" "github-repo-2" {
  name        = "People"
  description = "Repository for Charlie"

  visibility = "public"
}

data "github_repository_file" "index_html" {
  provider   = github
  repository = "whole_site"
  file       = "tech-test/index.html"
}

data "github_repository_file" "people_html" {
  provider   = github
  repository = "People"
  file       = "people.html"
}

data "github_repository_file" "article_1" {
  provider   = github
  repository = "marketing"
  file       = "news/article_1.html"
}

data "github_repository_file" "article_2" {
  provider   = github
  repository = "marketing"
  file       = "news/article_2.html"
}


resource "aws_s3_bucket" "tech_test" {
  bucket = "www.${var.domain_example}"
}

resource "aws_s3_bucket_policy" "make_bucket_public" {
  bucket = aws_s3_bucket.tech_test.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

resource "aws_s3_bucket_acl" "tech_test_bucket_acl" {
  bucket = aws_s3_bucket.tech_test.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "tech_test_site" {
  bucket = aws_s3_bucket.tech_test.id

  index_document {
    suffix = "index.html"
  }
}


data "aws_iam_policy_document" "bucket_policy" {

  statement {
    sid = "AllowedIPReadAccess"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::www.${var.domain_example}/*",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"

      values = ["0.0.0.0/0"]
    }

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_object" "index_html" {
  key          = "index.html"
  bucket       = aws_s3_bucket.tech_test.id
  content      = data.github_repository_file.index_html.content
  content_type = "text/html"

  etag = data.github_repository_file.index_html.sha
}

resource "aws_s3_object" "people_html" {
  key          = "people.html"
  bucket       = aws_s3_bucket.tech_test.id
  content      = data.github_repository_file.people_html.content
  content_type = "text/html"

  etag = data.github_repository_file.people_html.sha
}

resource "aws_s3_object" "news" {
  bucket = aws_s3_bucket.tech_test.id
  acl    = "public-read"
  key    = "news/"
  source = "/dev/null"
}

resource "aws_s3_object" "article_1_html" {
  key          = "news/article_1.html"
  bucket       = aws_s3_bucket.tech_test.id
  content      = data.github_repository_file.article_1.content
  content_type = "text/html"

  etag = data.github_repository_file.article_1.sha
}

resource "aws_s3_object" "article_2_html" {
  key          = "news/article_2.html"
  bucket       = aws_s3_bucket.tech_test.id
  content      = data.github_repository_file.article_2.content
  content_type = "text/html"

  etag = data.github_repository_file.article_2.sha
}