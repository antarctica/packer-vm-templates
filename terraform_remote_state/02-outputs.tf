#
# Defines outputs for resource attributes that may be needed in other projects, to be accessed through remote state

# To use these outputs in other projects a 'terraform_remote_state' resource is needed, see the README file for this
# project for more information

# 'antarctica/trusty' identifiers

output "ANTARCTICA-TRUSTY-3-0-0-AMI-ID" {
    value = "ami-ca0faab9"
}
output "ANTARCTICA-TRUSTY-3-0-1-AMI-ID" {
    value = "ami-61dc7812"
}
output "ANTARCTICA-TRUSTY-3-1-0-AMI-ID" {
    value = "ami-6315b410"
}
output "ANTARCTICA-TRUSTY-3-2-0-AMI-ID" {
    value = "ami-f950f98a"
}
output "ANTARCTICA-TRUSTY-3-3-0-AMI-ID" {
    value = "ami-c7229db4"
}
output "ANTARCTICA-TRUSTY-3-4-0-AMI-ID" {
    value = "ami-b66c1ac5"
}

# 'antarctica/centos7' identifiers

output "ANTARCTICA-CENTOS7-0-4-0-AMI-ID" {
    value = "ami-55d37726"
}
output "ANTARCTICA-CENTOS7-0-5-0-AMI-ID" {
    value = "ami-0316b770"
}
output "ANTARCTICA-CENTOS7-0-6-0-AMI-ID" {
    value = "ami-9b5ef7e8"
}
output "ANTARCTICA-CENTOS7-0-6-1-AMI-ID" {
    value = "ami-6e01b51d"
}
output "ANTARCTICA-CENTOS7-0-7-0-AMI-ID" {
    value = "ami-741ea107"
}
output "ANTARCTICA-CENTOS7-0-8-0-AMI-ID" {
    value = "ami-d95721aa"
}
