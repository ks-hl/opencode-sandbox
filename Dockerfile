FROM node:22-bookworm-slim

# Tools the agent's bash tool will want. Add your project's toolchain here
# (JDK, Gradle/Maven, Python, etc.) so the agent can build and run tests.
RUN apt-get update \
 && apt-get install -y --no-install-recommends git ripgrep ca-certificates bash \
 && rm -rf /var/lib/apt/lists/*

# Pinned to v1 so opencode.json's schema matches.
RUN npm install -g opencode-ai@1

COPY --from=oven/bun:1 /usr/local/bin/bun /usr/local/bin/bun
RUN ln -s /usr/local/bin/bun /usr/local/bin/bunx

# Writable HOME for whatever host UID the container runs as.
RUN mkdir -p /home/oc && chmod 777 /home/oc
