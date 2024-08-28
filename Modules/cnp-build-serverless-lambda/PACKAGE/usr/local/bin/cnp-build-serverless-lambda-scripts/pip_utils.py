#! /usr/bin/python3

import os
import shutil
import subprocess
import logging


def download_dependencies(git_path):
    venv_path = '/tmp/uploader/pip/venv/'
    os.chdir(venv_path)
    venv = subprocess.Popen('/usr/bin/python3 -m venv lambda', shell=True, encoding='utf-8', stdout=subprocess.PIPE,stderr=subprocess.PIPE)

    while True:
        live_output = venv.stdout.readline()
        if live_output == '' and venv.poll() is not None:
            break
        if live_output:
            print(live_output.strip(), flush=True)

    output, error = venv.communicate()
    if (output):
        logging.info(output)
    if (error):
        logging.error(error)
        exit(1)

    # folder_path = git_path + git_lambda_root + lambda_name

    # logging.info('Changing directory to ' + lambda_name + ' lambda folder')
    logging.info('Changing directory to ' + git_path)
    try:
        os.chdir(git_path)
    except Exception as e:
        logging.error('Error changing to lambda folder', exc_info=1)
        exit(1)

    logging.info('Checking for requirements.txt')
    if os.path.isfile(git_path + '/requirements.txt'):
        logging.info('requirements.txt found. Downloading dependencies')
        download_pip_requirements = subprocess.Popen('\"' + venv_path + 'lambda' + '/bin/pip\" install --disable-pip-version-check --ignore-installed -r requirements.txt -t \"' + git_path + '\"', shell=True, encoding='utf-8', stdout=subprocess.PIPE,stderr=subprocess.PIPE)

        while True:
            live_output = download_pip_requirements.stdout.readline()
            if live_output == '' and download_pip_requirements.poll() is not None:
                break
            if live_output:
                print(live_output.strip(), flush=True)

        output, error = download_pip_requirements.communicate()
        if (output):
            logging.info(output)
        if (error):
            logging.error(error)
            exit(1)

    else:
        logging.info('No requirements.txt found skipping dependency download')

    # if os.path.isdir(venv_path + lambda_name):
        # shutil.rmtree(venv_path + lambda_name)


