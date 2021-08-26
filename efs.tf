resource "aws_efs_file_system" "test-efs" {
  creation_token = "test-efs"

  tags = {
    Name = "test-efs"
  }
  
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
}

