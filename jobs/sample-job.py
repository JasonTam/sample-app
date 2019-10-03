import argparse


if __name__ == '__main__':
    parser = argparse.ArgumentParser()

    parser.add_argument('-a', '--arg1', dest='arg1', default='default_arg1')
    parser.add_argument('-b', '--arg2', dest='arg2', default='default_arg2')

    args = parser.parse_args()

    print(args)
