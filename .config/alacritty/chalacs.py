#!/usr/bin/env python

import os
import re
import yaml

# Initialise yaml path & file

YAML_NAME = "schemes.yml"
YAML_DIR = os.path.expanduser("~/.config/alacritty/")
YAML_PATH = os.path.join(YAML_DIR, YAML_NAME)

SCHEME_SEARCH_LINE = r"colors: \*(\S+)"
SCHEME_SEARCH_TEMPLATE = r"colors: *{}\n"

with open(YAML_PATH, "r") as scheme_yaml:
    scheme_conf = yaml.safe_load(scheme_yaml)
    scheme_yaml.seek(0)
    lines = scheme_yaml.readlines()

colors_line_index = -1
for i, line in enumerate(lines):
    match = re.search(SCHEME_SEARCH_LINE, line)
    if match is not None:
        current_scheme = match.group(1)
        colors_line_index = i

schemes_available = list(scheme_conf["schemes"].keys())
print(schemes_available)

sch_idx = schemes_available.index(current_scheme)
sch_idx = (sch_idx + 1) % len(schemes_available)

lines[sch_idx] = SCHEME_SEARCH_TEMPLATE.format(schemes_available[sch_idx])

with open(YAML_PATH, "w") as scheme_conf:
    for line in lines:
        scheme_conf.write(line)
