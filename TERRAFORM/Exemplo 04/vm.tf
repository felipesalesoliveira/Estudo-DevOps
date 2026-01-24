resource "aws_key_pair" "key" {
  key_name   = "key-aws-ec2"
  public_key = file("./aws-key.pub")
}