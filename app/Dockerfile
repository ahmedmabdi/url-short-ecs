# first stage : build stage
FROM python:3.12-slim AS builder 
#starts a new image layer using python3.12 slim version and names this stage builder - 
WORKDIR /app
# sets /app as the working directory inside the container- so commands and file paths are consistent 
COPY requirements.txt .
# copies requirements.txt into /app - copying dependeices first allows docker to cache this layer and avoids reistalling packages when only app code changes
RUN pip install --upgrade pip && \
    pip install --prefix=/install --no-cache-dir -r requirements.txt 
# upgrades pip, installs python dependencies into /install , dependencies are installed into a clean directory so we can copy only whats required into final image
COPY src/ ./src
# copies your application source code , app code changes frequently so its copied after dependencies to keep builds fast


# Second stage: runtime image - switch from distroless to python slim or debian
FROM python:3.12-slim
WORKDIR /app/src
ENV PYTHONPATH=/app 
COPY --from=builder /install /usr/local
COPY --from=builder /app/src /app/src
USER 65532:65532
EXPOSE 8080
CMD ["python", "-m", "uvicorn", "src.main:app", "--host=0.0.0.0", "--port=8080"]