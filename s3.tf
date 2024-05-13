#########
# Buckets
#########

resource "aws_s3_bucket" "POC-Images" {
    bucket = "cswain-challenge-images"
}

resource "aws_s3_object" "POC-arhive" {
    bucket = aws_s3_bucket.POC-Images.id
    key = "/archive/"
}

resource "aws_s3_object" "POC-memes" {
    bucket = aws_s3_bucket.POC-Images.id
    key = "/memes/"
}