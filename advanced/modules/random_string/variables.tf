variable "length" {
  description = "Length of the random string"
  type        = number
  validation {
    condition     = var.length > 5
    error_message = "Enter a value >5"
  }
}

variable "upper" {
  type        = bool
  description = "Include uppercase letters"
  default     = false
}

variable "special" {
  type        = bool
  default     = false
  description = "Include special characters"
}
