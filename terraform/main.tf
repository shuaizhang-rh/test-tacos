# This will wait 10s after the "next" resource
resource "time_sleep" "wait_10_seconds" {
  depends_on = [null_resource.next]

  create_duration = "10s"
}

resource "null_resource" "final" {
  depends_on = [time_sleep.wait_10_seconds]
}

# An alternate branch that starts from scratch
resource "null_resource" "parallel_start" {}

resource "time_sleep" "wait_3_seconds_parallel" {
  depends_on = [null_resource.parallel_start]

  create_duration = "3s"
}

resource "null_resource" "parallel_end" {
  depends_on = [time_sleep.wait_3_seconds_parallel]
}
