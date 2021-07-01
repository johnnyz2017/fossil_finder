const String serviceUrl = 'http://localhost:8000'; //local
// const String serviceUrl = 'http://foss-backend.herokuapp.com'; //heroku
// const String serviceUrl = "http://42.192.48.39:8080"; //tx cloud
// const String serviceUrl = 'http://47.108.137.45'; //aliyun
const String apiUrl = serviceUrl + '/api/v1';
const servicePath = {
  'testauth' : '/testauth',
  'posts' : '/posts',
  'categorieswithposts' : '/categories/allwithposts',
  'categorieswithoutposts' : '/categories/allwithoutposts',
  'categories' : '/categories',
  'unpublishedposts' : '/unpublishedposts',
  'publishedposts' : '/publishedposts',
  'privateposts' : '/privateposts',
  'postsfrommycomments' : '/postsfrommycomments',
  'comments' : '/comments',
  'users' : '/users',
  'changepw' : '/changepw',
  'sharedposts' : '/sharedposts',
};

const httpHeaders = {
  'Accept' : 'application/json, text/plain, */*',
  'Accept-Encoding' : 'gzpi, deflate, br',
  'Connection' : 'keep-alive',
  'Content-Type' : 'application/json'
};


const String TABLE_NAME_PBSETTING = 'pb_setting';
const String TABLE_NAME_UPLOADED = 'uploaded';

const double MARGIN = 0.06;
const double DMARGIN = 20;