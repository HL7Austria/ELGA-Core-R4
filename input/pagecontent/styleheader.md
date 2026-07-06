<style>
.notification-table {
  width: 100%;
  overflow-x: auto;
  max-height: 600px;
  overflow-y: auto;
}

.notification-table th,
.notification-table td {
  padding: 10px;
  background: #f5f5f5; /* Cell color */
  box-shadow: 0 0 0 3px #fff;
  text-align: left;
}
.notification-table th {
  background: #e4e4e4;
}

.table-responsive {
display: block;
width: 100%;
overflow-x: auto;
max-height: 600px;
overflow-y: auto;
}
.table-responsive > table {
width: 100%;}
.table-responsive th,
.table-responsive td {
  padding: 15px;
  background: #f5f5f5;
}
.table-responsive table {
  border-collapse: separate;
  border-spacing: 3px;
}
/* Kopfzeile sticky */
.table-responsive th {
  position: sticky;
  top: 0;
  background: rgb(228, 228, 228);
  z-index: 2;
}
/* Erste Spalte sticky */
.table-responsive th:first-child,
.table-responsive td:first-child {
  position: sticky;
  left: 0;
  background: rgb(228, 228, 228);
  z-index: 3;
}

.table-responsive th:first-child {
  position: sticky;
  top: 0;
  left: 0;
  background: rgb(228, 228, 228);
  z-index: 4;
}

.hinweisbox {
  border: 1px solid #156082;
  background: #dae8f8;
  padding: 8px 12px;
  border-radius: 4px;
  margin: 8px 0;
}

.codebox {
  border: 1px solid #ccc;
  background: #f5f5f5;
  padding: 8px 12px;
  border-radius: 4px;
  margin: 8px 0;
  font-family: "Courier New", Courier, monospace;
  color: #2d2d2d;
}


</style>

<script type="module"> import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs';</script>
