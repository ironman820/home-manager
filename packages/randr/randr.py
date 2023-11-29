from subprocess import CalledProcessError, PIPE, run, CompletedProcess
from typing import Optional


def run_time():
    xrandr_output: CompletedProcess = run(
        [
            "xrandr",
        ],
        stdout=PIPE,
        stderr=PIPE,
    )
    try:
        xrandr_output.check_returncode()
    except CalledProcessError as e:
        print("An error occurred running xrandr:")
        print(str(e))
        print(
            "\n".join(
                [
                    "The output from the command itself was:",
                    str(xrandr_output.stderr),
                ]
            )
        )
    output: list[str] = str(xrandr_output.stdout).splitlines()
    displays: list[dict[str, str or list[str]]] = []
    display: Optional[dict[str, str or list[str]]] = None
    for current_line in output:
        if " connected" in current_line:
            if display is not None:
                displays.append(display)
            display = {
                "name": current_line.split()[0],
            }
        modes: list[str] = []


if __name__ == "__main__":
    run_time()
