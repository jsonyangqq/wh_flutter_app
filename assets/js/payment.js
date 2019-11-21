$(function () {
    var dom = document.getElementById('rankingOpen');
    var myChart = echarts.init(dom);
    var date = ['8月11日', '8月12日', '8月13日', '8月14日', '8月15日', '8月16日'],
    option = null;
    option = {
        tooltip: {
            trigger: 'axis'
        },
        color: ["#FF7575", "#FFDD55", "#59C9FF"],
        legend: {
            data: ['第一名薪酬', '平均薪酬', '我的薪酬'],
            icon: 'circle'
        },
        grid: {
            // left: '3%',
            // right: '4%',
            // bottom: '3%',
            containLabel: true
        },
        xAxis: {
            type: 'category',
            boundaryGap: false,
            data: date,
            splitLine: {
                show: true
            },
        },
        yAxis: {
            type: 'value',
            axisLabel: {
                formatter: function () {
                    return "";
                }
            },
            splitLine: {
                show: false
            },
        },
        series: [
            {
                name: '第一名薪酬',
                type: 'line',
                stack: null,  // 数据堆叠，同个类目轴上系列配置相同的stack值后，后一个系列的值会在前一个系列的值上相加
                data: [120, 132, 101, 134, 90, 230, 210],
                hoverAnimation: false,
            },
            {
                name: '平均薪酬',
                type: 'line',
                stack: null, 
                data: [220, 182, 191, 234, 290, 330, 310],
                hoverAnimation: false
            },
            {
                name: '我的薪酬',
                type: 'line',
                stack: null, 
                data: [150, 232, 201, 154, 190, 330, 410],
                hoverAnimation: false
            }
        ]
    };
    myChart.setOption(option, true);

    // 关闭排名图
    openMore2($(".salaryRanking"))
})

// 发款项,扣款项展开关闭
function openMore(el) {
    var next = $(el).next("div").is(":hidden"); // 具体数据是否隐藏
    if (next) { // 原本隐藏
        $(el).addClass("openMore");
        $(el).next("div").show();
    } else { // 原本显示
        $(el).removeClass("openMore")
        $(el).next("div").hide();
        $(".details").hide();
        $(".details").prev("div").removeClass("openMore")
    }
}
// 工单金额和提成显示明细
function details(el) {
    var next = $(el).next().is(":hidden")
    if(next){
        $(".details").hide(); // 先关闭所有明细
        $(el).next().show();  // 打开当前点击的明细
        $(".oderPayment").find("div").not(el).removeClass("openMore"); // 清除其他点击过的样式
        $(".exrea").find("div").not(el).removeClass("openMore"); // 清除其他点击过的样式
        $(".reasons").find("div").not(el).removeClass("openMore"); // 清除其他点击过的样式
        $(el).addClass("openMore"); //  给当前点击项加样式
    }else{
        $(el).next().hide();
        $(el).removeClass("openMore");
    }
}

// 申诉
function complain(el) {
    console.log("申诉")
}

// 排名图展开关闭
function openMore2(el) {
    var next = $(el).next("div").is(":hidden");
    if (next) {
        // 隐藏
        $(el).next("div").show();
    } else {
        // 显示
        $(el).next("div").hide();
    }
}