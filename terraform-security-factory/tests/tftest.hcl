test "secure-s3-test" {
  module = "../modules/secure-s3"
  input = {
    bucket_name = "test-bucket-secure-123"
  }

  assert {
    condition = can(regex("^test-bucket-secure-.*", output.bucket_id))
    error_message = "Bucket ID doesn't match the expected pattern."
  }
}

