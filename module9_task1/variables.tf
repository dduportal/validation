
variable "configuration" {
  type = map(string)
  default = {
    "production" : "Awesome Production Server",
    "jenkins" : "Jenkins for Awesome Inc.",
    "jenkins-agent" : "Agent machine for builds"
  }
}
