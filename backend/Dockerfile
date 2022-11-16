FROM python:3.11 as python-base
RUN mkdir backend
WORKDIR /backend
COPY /pyproject.toml /backend
RUN pip3 install poetry
RUN poetry config virtualenvs.create false
RUN poetry install
COPY . .
CMD ["uvicorn", "main:app", "--reload", "--host", "0.0.0.0", "--port", "8000"]
