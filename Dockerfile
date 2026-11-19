FROM node:24-bookworm-slim
WORKDIR /app
COPY --chown=node:node iniciar.mjs ./
COPY --chown=node:node web ./web
COPY --chown=node:node migrations ./migrations
RUN mkdir -p /app/datos && chown node:node /app/datos
ENV PORT=8080 BITACORA_HOST=0.0.0.0 BITACORA_DATA=/app/datos
EXPOSE 8080
USER node
CMD ["node","iniciar.mjs"]
