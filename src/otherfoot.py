from __future__ import (absolute_import, division, print_function, unicode_literals)
from builtins import *

import sys
from argparse import ArgumentParser, ArgumentDefaultsHelpFormatter


def set_up_parser():
    parser = ArgumentParser(description=__doc__,
                            formatter_class=ArgumentDefaultsHelpFormatter)
    return parser


def main():
    args = set_up_parser().parse_args()

    if __name__ == "__main__":
        sys.exit(main())
