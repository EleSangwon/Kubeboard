FROM node:16.8.0

 RUN mkdir /web

 WORKDIR /web

 COPY  package*.json ./

 RUN npm install
 
 COPY . .

 EXPOSE 3000

 CMD ["node", "app.js"]
