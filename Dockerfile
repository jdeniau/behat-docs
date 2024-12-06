FROM python:3.12

WORKDIR /workspace

COPY requirements.txt .
RUN python -m pip install --upgrade --no-cache-dir pip setuptools
RUN python -m pip install --upgrade --no-cache-dir -r requirements.txt
