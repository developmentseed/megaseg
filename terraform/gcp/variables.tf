variable "location" {
  type        = string
  description = "Location of the resources"
  default     = "us-central1"
  # Check available zones for instance type in https://cloud.google.com/compute/docs/regions-zones
  # For N1 machines, with GPU:
  ## Europe
  # europe-west1 - 	St. Ghislain, Belgium, Europe
  # europe-west2 - London, England, Europe
  # europe-west3 - Frankfurt, Germany Europe
  # europe-west4 - Eemshaven, Netherlands, Europe
  # europe-west6 - 	Zurich, Switzerland, Europe
  ## North America
  # northamerica-northeast1 - Montréal, Québec, North America
  # us-central1 - Council Bluffs, Iowa, North America
  # us-east1 - Moncks Corner, South Carolina, North America
  # us-east4 - Ashburn, Virginia, North America
  # us-west1 - The Dalles, Oregon, North America
  # us-west2 - 	Los Angeles, California, North America
  # us-west4 - Las Vegas, Nevada, North America 
}

variable "instance-type" {
  type        = string
  description = "Instance type to deploy"
  default     = "n1-standard-4"
}

variable "project" {
  type        = string
  description = "Project"
  default     = "research-mml"
}
