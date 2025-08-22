# ====== Stage 1: Build Angular ======
FROM node:20-alpine AS build

WORKDIR /app

COPY package*.json ./
# npm ci es más reproducible; usa npm install si no tienes package-lock.json
RUN npm ci

COPY . .
RUN npm run build -- --configuration=production

# ====== Stage 2: Servir con Nginx ======
FROM nginx:1.27-alpine

# (Recomendado) Config SPA para ruteo de Angular
# COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# 👇 clave: copiar exactamente donde está el index.html generado
COPY --from=build /app/dist/proyecto_prueba/browser/ /usr/share/nginx/html/

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
