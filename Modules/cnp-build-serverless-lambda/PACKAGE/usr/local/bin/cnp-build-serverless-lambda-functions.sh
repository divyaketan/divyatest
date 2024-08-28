function main() {
  PYTHONPATH=${PYTHONPATH:-/usr/local/bin/cnp-build-serverless-lambda-scripts}

  . "cnp-build-serverless-lambda-$1.sh" "$2"
}
