component {
	public function init(required any variable, struct options={}) {
		if (NOT isDefined('options.sort')) options.sort = true;
		if (NOT isDefined('options.expand')) options.expand = true;
		return '
			<style>
			table.dmp, table.dmp th, table.dmp td {
				border: 2px solid;
				border-collapse:collapse;
				font-size:xx-small;
				font-family:verdana,arial,helvetica,sans-serif;
				padding:3px;
				text-align:left;
				vertical-align:top;
			}
			table.dmp .header th {
				color:##fff;
				cursor:pointer;
				padding:5px;
			}
			table.dmp .label {
				text-transform:uppercase;
			}
			table.dmp .collapsed .header {
				font-style:italic;
			}
			table.dmp .collapsed td {
				display:none;
			}

			table.dmp.query,  table.dmp.query>tbody>tr>th,  table.dmp.query>tbody>tr>td  { border-color: ##848; }
			table.dmp.array,  table.dmp.array>tbody>tr>th,  table.dmp.array>tbody>tr>td  { border-color: ##060; }
			table.dmp.struct, table.dmp.struct>tbody>tr>th, table.dmp.struct>tbody>tr>td { border-color: ##00c; }
			table.dmp.array> tbody>tr.header { background-color:##090; }
			table.dmp.query> tbody>tr.header { background-color:##a6a; }
			table.dmp.struct>tbody>tr.header { background-color:##44c; }
			table.dmp.query> tbody>tr.label,
			table.dmp.query> tbody>tr>td.label { background-color:##fdf; }
			table.dmp.array> tbody>tr>td.label { background-color:##cfc; }
			table.dmp.struct>tbody>tr>td.label { background-color:##cdf; }
			</style>' & dumpThing(variable, options);
	}

	private function dumpThing(required any variable, required struct options) {
		return
			isSimpleValue(variable) ? (variable == '' ? '[empty string]' : variable) : (
			isQuery(variable) ? dumpQuery(variable, options) : (
			isArray(variable) ? dumpArray(variable, options) : (
			isStruct(variable) ? dumpStruct(variable, options) : (
			'UNABLE TO DUMP VARIABLE: UNKNOWN TYPE'))));
	}

	private function dumpQuery(required query qry, required struct options) {
		var rows = [];
		var fields = [];
		var qryMetadata = GetMetaData(qry);
		for (colMetadata in qryMetadata) {
			arrayAppend(fields, colMetadata.Name);
		}
		if (options.sort) arraySort(fields, 'textnocase');
		ArrayAppend(rows, '<td></td><td>' & ArrayToList(fields, '</td><td>') & '</td>');
		for (var i = 1; i <= qry.recordCount; i++) {
			var rowData = [ i ];
			for (var field in fields) {
				ArrayAppend(rowData, qry[field][i] == '' ? '[empty string]' : qry[field][i]);
			}
			ArrayAppend(rows, '<td class="label">' & ArrayToList(rowData, '</td><td>') & '</td>');
		}
		return '
			<table class="dmp query"><tbody class="#options.expand ? '' : 'collapsed'#">
				<tr class="header" onclick="var cl=this.parentNode.classList;cl.contains(''collapsed'')?cl.remove(''collapsed''):cl.add(''collapsed'')">
					<th colspan="#ArrayLen(fields)+1#">query</th></tr>
				<tr class="label">#ArrayToList(rows, "</tr>" & Chr(13) & Chr(10) & "<tr>")#</tr>
			</table>';
	}

	private function dumpArray(required array ary, required struct options) {
		var rows = [];
		for (var val in ary) {
			ArrayAppend(rows, '<td class="label">#ArrayLen(rows)+1#</td><td>#dumpThing(val, options)#</td>');
		}
		return '
			<table class="dmp array"><tbody class="#options.expand ? '' : 'collapsed'#">
				<tr class="header" onclick="var cl=this.parentNode.classList;cl.contains(''collapsed'')?cl.remove(''collapsed''):cl.add(''collapsed'')">
					<th colspan="2">array</th></tr>
				<tr>#ArrayToList(rows, "</tr>" & Chr(13) & Chr(10) & "<tr>")#</tr>
			</table>';
	}

	private function dumpStruct(required struct strct, required struct options) {
		var rows = [];
		for (var key in strct) {
			ArrayAppend(rows, '<td class="label">#key#</td><td>#dumpThing(strct[key], options)#</td>');
		}
		return '
			<table class="dmp struct"><tbody class="#options.expand ? '' : 'collapsed'#">
				<tr class="header" onclick="var cl=this.parentNode.classList;cl.contains(''collapsed'')?cl.remove(''collapsed''):cl.add(''collapsed'')">
					<th colspan="2">struct</th></tr>
				<tr>#ArrayToList(rows, "</tr>" & Chr(13) & Chr(10) & "<tr>")#</tr>
			</table>';
	}
}
