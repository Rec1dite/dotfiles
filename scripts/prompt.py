#!/usr/bin/env python3
# flake8: noqa

import sys
import re
from pathlib import Path
import subprocess

def substitute_links(markdown_path: Path) -> str:
    content = markdown_path.read_text(encoding='utf-8')

    def replacer(match):
        title = match.group(1)
        file_path = match.group(2).lstrip('/')
        file_full_path = '.' / Path(file_path)

        if not (file_full_path.exists() and file_full_path.is_file()):
            return f"({title})[{file_path}]"

        extension = file_full_path.suffix.lstrip('.') or ''
        file_content = file_full_path.read_text(encoding='utf-8')

        title = title.strip()
        title = title + " " if len(title) > 0 else ""

        return f"{title}[{file_path}]:\n```{extension}\n{file_content}\n```"

    return re.sub(r'\[(.*)\]\((.*)\)', replacer, content)

def clip(txt):
    try: p = subprocess.Popen(['xclip', '-selection', 'clipboard'], stdin=subprocess.PIPE)
    except FileNotFoundError:
        try: p = subprocess.Popen(['xsel', '--clipboard', '--input'], stdin=subprocess.PIPE)
        except FileNotFoundError: return False
    p.communicate(input=txt.encode('utf-8'))
    return True


def main():
    if len(sys.argv) < 2:
        print("\n\033[93mUsage\033[0m: prompt <markdown_file> [-p,--print]")
        sys.exit(1)

    args = sys.argv[1:]
    prnt = '-p' in args or '--print' in args
    args = filter(lambda x: x != '-p' and x != '--print', args)

    markdown_file = Path(f".doc/prompt/{sys.argv[1]}.md")
    if not markdown_file.exists():
        print(f"\033[91mErr\033[0m: Markdown file '{markdown_file}' not found.")
        sys.exit(1)

    rendered = substitute_links(markdown_file)
    if prnt: print(rendered)
    else:
        if clip(rendered): print("\n\033[92m✔\033[0m Copied to clipboard.")
        else:              print("\n\033[91mErr\033[0m: Failed to copy to clipboard")


if __name__ == '__main__':
    main()