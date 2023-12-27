$(document).ready(function() {
    $(".sortable").click(function() {
      var table = $(this).closest("table");
      var rows = table.find("tbody > tr").get();

      var ascending = $(this).hasClass("asc");
      $(this).toggleClass("asc desc");

      var columnIndex = $(this).index();

      rows.sort(function(a, b) {
        var aValue = $(a).find("td").eq(columnIndex).text(); 
      var bValue = $(b).find("td").eq(columnIndex).text(); 
        return ascending ? aValue.localeCompare(bValue) : bValue.localeCompare(aValue);
      });

      table.children("tbody").empty().append(rows);
    });
    // Set default sort class
    $(".sortable").first().addClass("asc");
  });