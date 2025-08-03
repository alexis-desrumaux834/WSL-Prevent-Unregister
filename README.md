# WSL-Prevent-Unregister (PowerShell Edition) 🛡️

Tired of nuking your Linux distro by accident? This PowerShell script hijacks wsl --unregister and asks: “Are you really sure?”

---

## The Problem

Running `wsl --unregister <DistroName>` in PowerShell immediately and irreversibly deletes a WSL distribution, along with all its data. There’s **no confirmation**, no “Are you sure?”, no second chance. One misplaced keystroke and days—or even weeks—of work can vanish instantly.

---

## The Solution

This script injects a smart wrapper function directly into your **PowerShell profile**. Once installed, anytime you use `wsl` in PowerShell, your input is inspected:

- If the command includes `--unregister`, you’ll be prompted for confirmation.
- Otherwise, it behaves exactly like the original `wsl.exe`.

No PATH changes, no extra files—just safe and native PowerShell scripting.

---

## Features

- **⚠️ Safe Unregistering:** Blocks accidental deletion by requiring a typed `yes` confirmation.
- **🧾 Distro Awareness:** Displays the list of installed distributions before confirming deletion.
- **🚀 Bypass Flag:** Use `--delete-i-know-what-i-am-doing` to skip the prompt for scripting or advanced usage.
- **👻 Silent Integration:** Adds the logic to your existing PowerShell profile without breaking anything else.
- **🔧 Zero-Trace Installation:** Everything happens inside PowerShell—no system-wide modifications.

---

## Installation

Just run this one-liner in a **PowerShell terminal** (you don’t need admin rights):

```powershell
irm https://raw.githubusercontent.com/alexis-desrumaux834/WSL-Prevent-Unregister/refs/heads/main/install-wsl-protect.ps1 | iex
```

> 🔐 *Note: You may need to allow script execution temporarily with:*
> 
> ```powershell
> Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
> ```

After installation, restart any open PowerShell sessions to activate the updated profile.

---

## Usage

Continue using `wsl` as usual. Nothing changes—until it matters.

### ❌ Dangerous Operation

```powershell
PS C:\> wsl --unregister Ubuntu

WARNING: You are about to delete a WSL distribution.
This operation will permanently erase all data within the specified distribution.

Ubuntu
Debian
docker-desktop

Do you wish to proceed? (yes/no): 
```

If you type anything other than `yes`, the operation is cancelled.

### ✅ Power User Shortcut

Skip the prompt by explicitly declaring your intent:

```powershell
wsl --unregister Ubuntu --delete-i-know-what-i-am-doing
```

No warning, no prompt—just execution.

### ✅ Everything Else

All other commands work as expected:

```powershell
wsl --list --verbose
```

---

## Uninstallation 🗑️

To remove the script:

1. Open PowerShell.
2. Edit your PowerShell profile:

    ```powershell
    notepad $PROFILE
    ```

3. Manually remove the function block that starts with:

    ```powershell
    function wsl {
    ```

4. Save and close. Restart your terminal.

> You can also write a removal script if you prefer a fully automated uninstall—let me know if you'd like one.
