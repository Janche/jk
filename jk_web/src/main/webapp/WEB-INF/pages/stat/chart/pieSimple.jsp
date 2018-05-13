<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>amCharts examples</title>
    <link rel="stylesheet"
          href="${pageContext.request.contextPath }/components/amchartNew/style.css"
          type="text/css">
    <script
            src="${pageContext.request.contextPath }/components/amchartNew/amcharts/amcharts.js"
            type="text/javascript"></script>
    <script
            src="${pageContext.request.contextPath }/components/amchartNew/amcharts/pie.js"
            type="text/javascript"></script>
    <script
            src="${pageContext.request.contextPath }/components/amchartNew/amcharts/plugins/export/export.js"></script>
    <link type="text/css"
          href="${pageContext.request.contextPath }/components/amchartNew/amcharts/plugins/export/export.css"
          rel="stylesheet">
    <style>
        body, html {
            height: 100%;
            padding: 0;
            margin: 0;
            overflow: hidden;
            font-size: 11px;
            font-family: Verdana;
        }

        #chartdiv {
            width: 100%;
            height: 100%;
        }
    </style>

    <script type="text/javascript">
        var chartdata = ${result };
        var chart = AmCharts
            .makeChart(
                "chartdiv",
                {
                    "type" : "pie",
                    "titles" : [ {
                        "text" : "生产厂家销售情况",
                        "size" : 16
                    } ],
                    "dataProvider" : chartdata,
                    "valueField" : "amount",
                    "titleField" : "factory",
                    "startEffect" : "elastic",
                    "startDuration" : 2,
                    "labelRadius" : 15,
                    "innerRadius" : "50%",
                    "depth3D" : 10,
                    "balloonText" : "[[title]]<br><span style='font-size:14px'><b>[[value]]</b> ([[percents]]%)</span>",
                    "angle" : 15,
                    "legend" : {
                        "position" : "right"
                    },
                    "export" : {
                        "enabled" : true,
                        "position" : "top-left",
                        "legend" : {
                            "position" : "bottom"
                        }
                    }
                });
    </script>
</head>

<body>
<div id="chartdiv"></div>
</body>

</html>