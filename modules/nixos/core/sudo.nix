{
  # Replace classic sudo with sudo-rs (Rust rewrite). Smaller TCB and
  # memory-safe, while staying drop-in for the basic NOPASSWD/wheel
  # workflow this repo uses.
  #
  # NOPASSWD is intentional: every host here is single-admin, ssh is
  # locked to publickey + AllowUsers tnmt, so requiring a password
  # adds daily friction without changing the realistic threat model
  # (an attacker who has tnmt's account already loses to keyloggers
  # / session hijack regardless of password).
  #
  # execWheelOnly setgids the binary to wheel so non-wheel processes
  # (web servers, sshd, etc.) cannot even invoke sudo, mitigating
  # CVE-2021-3156-class privesc vectors.
  security.sudo.enable = false;
  security.sudo-rs = {
    enable = true;
    wheelNeedsPassword = false;
    execWheelOnly = true;
  };
}
