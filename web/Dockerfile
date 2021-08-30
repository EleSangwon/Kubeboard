FROM node:16.8.0

 RUN mkdir /web

 WORKDIR /web

 COPY . /web

 RUN npm install

 EXPOSE 3000

 CMD ["npm", "start"]