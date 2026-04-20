#First stage build
FROM python:3.12-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --prefix=/install --no-cache-dir -r requirements.txt
COPY src/ ./src

#Second stage runtime
FROM python:3.12-slim
WORKDIR /app/src

ENV PYTHONPATH=/app 
COPY --from=builder /install /usr/local
COPY --from=builder /app/src /app/src

USER 65532:65532
EXPOSE 8080
CMD ["python", "-m", "uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8080"]