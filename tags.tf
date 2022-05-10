locals {
  default_tags = merge(
    {
      "Environment" = format("%s", var.environment)
    },
    var.tags
  )
}
