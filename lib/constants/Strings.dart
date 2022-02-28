class Strings {
  //ngrok http https://localhost:8080 -host-header="localhost:8080"
  static String baseUrl = 'https://31ec-178-182-235-162.ngrok.io';
  static String getAllProceduresUrl = baseUrl + '/katalog';
  static String getAllCategoriesUrl = getAllProceduresUrl + '/kategorie';
  static String planner_url = baseUrl + '/app/planner/';
  static String summary_url = baseUrl + '/app/summary/';
}
