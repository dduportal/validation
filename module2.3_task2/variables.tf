
variable "configuration" {
  type = map(map(string))
  default = {
    "production" : {
      "description" : "Awesome Production Server",
      "userdata-file" : "default.yml",
    },
    "jenkins" : {
      "description" : "Jenkins for Awesome Inc.",
      "userdata-file" : "default.yml",
    },
    "jenkins-agent" : {
      "description" : "Agent machine for builds",
      "userdata-file" : "ci-agent.yml",
    },
  }
}



variable "configuration" { default = { "honkhonk" : { "description" : "Honk Honk", "userdata-file" : "default.yml" } } }
