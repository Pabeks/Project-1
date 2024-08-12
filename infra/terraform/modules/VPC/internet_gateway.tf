resource "aws_internet_gateway" "paje-ig" {
  vpc_id = aws_vpc.paje-vpc.id

  tags = merge(
    var.tags,
    {
      Name = format("%s-%s", var.name, "IG")
    }
  )
}

