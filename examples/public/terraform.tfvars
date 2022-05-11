# fixtures
region               = "eu-west-2"
bucket_name          = "my-foobar-bucket-sftp"
transfer_server_name = "sftp-server-name"

sftp_users = {
  "foo" = {
    user_name  = "foo",
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8+IzBkxAFp0uN7g+zoIGYqlI+VAfwFEvqXMvfGX5fCxOPCyjFxxkGgQZAvXkRsyNtnjNdeo+lfL5AGEy8+zz3iYqfBvGkU0ZCzyGLoIYiuw0gzq/g+k8kxsMx1cAt6SbamjkR8wbO65pMOLMDGeSsIyYGUMR4HF2Sjs9KQ0HP4AW3uHDmVN61M9iwoOvcMNzC0IwxSGom77+WFaTreWaClmJlOOUo/TEq0wSxLx4no6NyWJJC/Arv7omUA3OQYSnOe9TfA08+g+ufmOSvh5Jw/J/CqegoVkgR2iWO5osA2mDwZ2qofCvXpp0SCMcMc285YYCNf/scHpu10rKpEvlt2qk1jwFlBBWlSobj0/INJWL+UeomRTaoC4L83bS5pEa6SLwPc/f3oXdUrkPy2PpEefpILqs6HhMZVqg13e60VxFABAcq4nHMQc9MHaoiRh1iE6B/Q1WnhIqkcgu2MMdCUMXID95Z6k7mYVMLCdzjAAeAZfhoSFhGWK9QU5i1E4kV64xSyhW8IxcGMTBxeEabivbmaCmy0XgmUjNT7L2YKOgSZEgSneGgs9NLtoMTU+fdHqCc9lGLg6UEyl59o/NqmAf9u4FdnGG4sxA7Kar9roZ0ynBW3P6YWiGN42xrRhJH8LCJMMsLBhC72F5IfMf92sLovkjA1GLyynFCoXHApQ== foo@example.com"
  }
}

environment = "notprod"

tags = {
  Owner   = "Foo"
  Project = "sample"
}
