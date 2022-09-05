provider "aws" {
  region = "eu-west-1"
  access_key = var.access_key
  secret_key = var.secret_key
}
provider "github" {
  token = var.token
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

resource "aws_s3_bucket" "tech_test" {

  bucket = "www.${var.domain_example}"
  acl    = "public-read"
  policy = data.aws_iam_policy_document.bucket_policy.json

  website {
    index_document = "index.html"
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

resource "aws_s3_bucket_object" "index.html" {
  key          = "index.html"
  bucket       = aws_s3_bucket.tech_test.id
  source       = "index.html"
  content_type = "text/html"

  etag = filemd5("index.html")
}

resource "aws_s3_bucket_object" "people.html" {
  key          = "people.html"
  bucket       = aws_s3_bucket.tech_test.id
  source       = "people.html"
  content_type = "text/html"

  etag = filemd5("error.html")
}

resource "aws_s3_bucket_object" "news" {
    bucket = aws_s3_bucket.tech_test.id
    acl    = "public-read"
    key    = "news/"
    source = "/dev/null"
}

resource "aws_s3_bucket_object" "article_1.html" {
  key          = "news/article_1.html"
  bucket       = aws_s3_bucket.tech_test.id
  source       = "article_1.html"
  content_type = "text/html"

  etag = filemd5("article_1.html.html")
}

resource "aws_s3_bucket_object" "article_2.html" {
  key          = "news/article_2.html"
  bucket       = aws_s3_bucket.tech_test.id
  source       = "article_2.html"
  content_type = "text/html"

  etag = filemd5("article_2.html.html")
}