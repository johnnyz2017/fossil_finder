

class GlobalConfig{
}

// const String serviceUrl = 'http://localhost:8000';
const String serviceUrl = 'http://foss-backend.herokuapp.com';
const String apiUrl = serviceUrl + '/api/v1';
const servicePath = {
  'posts' : '/post',
  'categories' : '/category'
};

const httpHeaders = {
'Accept' : 'application/json, text/plain, */*',
'Accept-Encoding' : 'gzpi, deflate, br',
'Connection' : 'keep-alive',
'Content-Type' : 'application/json'
};