resource "null_resource" "previous" {}

resource "time_sleep" "wait_5_seconds" {
  depends_on = [null_resource.previous]
  create_duration = "5s"
}

resource "null_resource" "next" {
  depends_on = [time_sleep.wait_5_seconds]
}

resource "time_sleep" "wait_10_seconds" {
  depends_on = [null_resource.next]
  create_duration = "10s"
}

resource "null_resource" "final" {
  depends_on = [time_sleep.wait_10_seconds]
}

# --- Parallel branch for dependency graph testing ---

resource "null_resource" "parallel_start" {}

resource "time_sleep" "wait_3_seconds_parallel" {
  depends_on = [null_resource.parallel_start]
  create_duration = "3s"
}

resource "null_resource" "parallel_end" {
  depends_on = [time_sleep.wait_3_seconds_parallel]
}

# --- Count-based resources (creates 3 similar resources) ---

resource "null_resource" "batch_step" {
  count = 3
  triggers = {
    index = count.index
  }
}

# --- Conditional execution with variable (optional future test) ---

variable "enable_extra_step" {
  type    = bool
  default = false
}

resource "null_resource" "optional_step" {
  count      = var.enable_extra_step ? 1 : 0
  depends_on = [null_resource.final]
}
