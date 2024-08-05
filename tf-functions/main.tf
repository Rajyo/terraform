terraform {}

locals {
  value = "Hello World !"
}

variable "string_lists" {
  type = list(string)
  default = [ "Gandalf", "Lady Galadriel", "Saruman" ]
}

output "output" {
  #value = lower(local.value)
  #value = upper(local.value)
  #value = startswith(local.value, "Hello")
  #value = split(" ", local.value)
  #value = max(1,2,3,4,5)
  #value = abs(-15)
  #value = length(var.string_lists)
  #value = {for list in var.string_lists: list => length(list)}
  #value = join(" : ", var.string_lists)
  #value = contains(var.string_lists, "Gandalf")
  value = toset(var.string_lists)
}