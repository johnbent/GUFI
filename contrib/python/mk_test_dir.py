#! /bin/env python3

import os
import argparse
import time

def create_structure(base_path, depth, width, size):
    if depth < 0:
        return

    # Create the base directory if it does not exist
    if not os.path.exists(base_path):
        os.makedirs(base_path)

    # Create S empty files in the base directory
    for i in range(size):
        open(os.path.join(base_path, f'file.{i}'), 'w').close()

    # Create W subdirectories and recurse
    for i in range(width):
        subdir = os.path.join(base_path, f'dir.{i}')
        create_structure(subdir, depth - 1, width, size)

def main():
    parser = argparse.ArgumentParser(description='Create a nested directory and file structure.')
    parser.add_argument('-d', '--depth', type=int, default=5, help='Depth of the directory tree')
    parser.add_argument('-w', '--width', type=int, default=5, help='Number of subdirectories at each level')
    parser.add_argument('-s', '--size', type=int, default=10, help='Number of files in each directory')
    parser.add_argument('-p', '--path', type=str, default=os.getcwd(), help='Base path for creating structure')

    args = parser.parse_args()

    depth = args.depth
    width = args.width
    size = args.size
    base_path = args.path

    # Create root directory with current epoch
    epoch = int(time.time())
    root_dir = os.path.join(base_path, f'root.{epoch}')
    
    create_structure(root_dir, depth, width, size)

if __name__ == '__main__':
    main()

