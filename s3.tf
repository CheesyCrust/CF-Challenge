#########
# Buckets
#########

resource "aws_s3_bucket" "POC-Images" {
    bucket = "cswain-challenge-images"
}

resource "aws_s3_object" "POC-archive" {
    bucket = aws_s3_bucket.POC-Images.id
    key = "/archive/"
}

resource "aws_s3_object" "POC-memes" {
    bucket = aws_s3_bucket.POC-Images.id
    key = "/memes/"
}

resource "aws_s3_bucket" "POC-Logs" {
    bucket = "cswain-challenge-logs"
}

resource "aws_s3_object" "POC-active" {
    bucket = aws_s3_bucket.POC-Logs.id
    key = "/active/"
}

resource "aws_s3_object" "POC-inactive" {
    bucket = aws_s3_bucket.POC-Logs.id
    key = "/inactive/"
}


###########
#Policies
###########

resource "aws_s3_bucket_lifecycle_configuration" "POC-Glacier-Move-images" {
    depends_on = [aws_s3_bucket.POC-Images]
    bucket = aws_s3_bucket.POC-Images.id

    rule {
        id = "90Days-Storage"

        filter {
            prefix = "memes/"
        }

        transition {
            days = 90
            storage_class = "GLACIER"
        }
    status = "Enabled"
    }
}

resource "aws_s3_bucket_lifecycle_configuration" "POC-Glacier-Move-ActiveLogs" {
    depends_on = [aws_s3_bucket.POC-Logs]
    bucket = aws_s3_bucket.POC-Logs.id

        rule {
            id = "90Days-Storage"

            filter {
                prefix = "active/"
            }

            transition {
                days = 90
                storage_class = "GLACIER"
            }
        status = "Enabled"
        }

        rule {
            id = "90Days-Deletion"

            filter {
                prefix = "inactive/"
            }

            expiration {
                days = 90
            }
        status = "Enabled"
        }
}