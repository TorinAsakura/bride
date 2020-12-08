$(document).ready(function(){
    if ($('#main-container').attr('controller') != 'seating_plans') {
    } else {
        var tableDraggableParams = {
            cursor: "move",
            helper: "original",
            containment: "#chart",
            snap: true,
            snapMode: "outer",
            distance: 15,
        }

        var tableResizableParams = {
            containment: "#chart",
            grid: [10, 10],
            minHeight: 100,
            minWidth: 100,
            resize: function () {
                $(this).css({"opacity": "0.75"});
                $(this).children(".seat, .seating-icon").css({"display": "none"});

                CenterTableTitle(this);
            },
            stop: function () {
                $(this).css({"opacity": "1"});

                CenterTableTitle($(this));
                if ($(this).attr('type') == 'square') {
                    SquareTableSeatsPosition($(this));
                } else {
                    RoundTableSeatsPosition($(this));
                }

                $(this).children(".seat, .seating-icon").css({"display": "block"});
            }
        }

        var guestDraggableParams = {
            helper: 'clone',
            // opacity : 1,
            zIndex: 999
            // stack: { group: '.guest', min: 50 }
        }

        var previousGuestSeat = false;
        var seatDroppableParams = ({
            tolerance: 'pointer',
            hoverClass: 'test-class',
            accept: '.guest.ui-draggable',
            drop: function (event, ui) {
                // clear previous seat
                if (previousGuestSeat && previousGuestSeat.hasClass('seat')) {
                    previousGuestSeat.removeClass(previousGuestSeat.attr('type'));
                    previousGuestSeat.addClass('empty');
                    previousGuestSeat.attr('type', 'empty');
                }
                previousGuestSeat = false;

                // clear seat and move previous guest to guest-list
                if (!$(this).hasClass('empty')) {
                    var oldGuest = $(this).children();
                    oldGuest.css({"margin-left": "0"});
                    $('#guest-list').append(oldGuest);
                    $(this).removeClass(oldGuest.attr('type'));
                }

                $(this).append(ui.draggable);
                CenterGuestName(ui.draggable);
                $(this).removeClass('empty');
                $(this).addClass(ui.draggable.attr('type'));
                $(this).attr("type", ui.draggable.attr('type'));
            },
            activate: function (event, ui) {
                previousGuestSeat = ui.draggable.parent();
            },
        });

        $('#guest-list.ui-droppable').droppable({
            tolerance: 'pointer',
            accept: '.guest.ui-draggable',
            drop: function (event, ui) {
                // clear previous seat
                if (previousGuestSeat && previousGuestSeat.hasClass('seat')) {
                    previousGuestSeat.removeClass(previousGuestSeat.attr('type'));
                    previousGuestSeat.addClass('empty');
                    previousGuestSeat.attr('type', 'empty');
                }
                previousGuestSeat = false;

                $(this).append(ui.draggable.css({"margin-left": "0"}));
            },
            activate: function (event, ui) {
                previousGuestSeat = ui.draggable.parent();
            }
        });
        $('.guest.ui-draggable').draggable(guestDraggableParams);

        function CenterTableTitle(table) {
            var title = $(table).children('.title');
            var marginTopDelta = +title.height() / 2;
            title.css({"margin-top": '-' + marginTopDelta + 'px'});
        }

        /**
         * @return {boolean}
         */
        function RoundTableSeatsPosition(table) {
            var countSeatsRound = table.children('.seat.round').length;
            if (countSeatsRound != 0) {
                var widthSeats = 30;

                var tableWidth = table.width();
                var tableHeight = table.height();

                // -15 = margin
                var tableCenterHeight = tableHeight / 2 - 15;
                var tableCenterWidth = tableWidth / 2 - 15;

                // 45 = seat.margin + seat.width
                var tableRadiusHeight = tableCenterHeight + 45;
                var tableRadiusWidth = tableCenterWidth + 45;

                var alfaDelta = 2 * Math.PI / countSeatsRound;
                var alfa = Math.PI;

                // init left and top positions for round-seats
                for (var i = table.children('.seat.round').length - 1; i >= 0; i--) {
                    var seat = table.children('.seat.round')[i];

                    // topPosition = centerX + radiusA * cos(fi)
                    // leftPosition = centerY + radiusB * sin(fi)
                    var topPosition = tableCenterHeight + tableRadiusHeight * Math.cos(alfa);
                    var leftPosition = tableCenterWidth + tableRadiusWidth * Math.sin(alfa);
                    alfa += alfaDelta;
                    $(seat).css({ "left": leftPosition + "px", "top": topPosition + "px"});
                }
            }
            return false;
        }

        function SquareTableSeatsPosition(table) {
            var widthSeat = 30;
            var tableWidth = table.width();
            var tableHeight = table.height();

            var countSeatsTop = table.children('.seat.top').length;
            var emptyWidthTop = tableWidth - countSeatsTop * widthSeat;
            var emptyDistWidthTop = emptyWidthTop / (countSeatsTop + 1);

            var countSeatsBottom = table.children('.seat.bottom').length;
            var emptyWidthBottom = tableWidth - countSeatsBottom * widthSeat;
            var emptyDistWidthBottom = emptyWidthBottom / (countSeatsBottom + 1);

            var countSeatsLeft = table.children('.seat.left').length;
            var emptyWidthLeft = tableHeight - countSeatsLeft * widthSeat;
            var emptyDistWidthLeft = emptyWidthLeft / (countSeatsLeft + 1);

            var countSeatsRight = table.children('.seat.right').length;
            var emptyWidthRight = tableHeight - countSeatsRight * widthSeat;
            var emptyDistWidthRight = emptyWidthRight / (countSeatsRight + 1);

            // init left position for bottom-seats
            for (var i = table.children('.seat.bottom').length - 1; i >= 0; i--) {
                var seat = table.children('.seat.bottom')[i];
                var leftPosition = emptyDistWidthBottom + ( (i) * (widthSeat + emptyDistWidthBottom) );
                $(seat).css({ "left": leftPosition + "px"});
            }

            // init left position for top-seats
            for (var i = table.children('.seat.top').length - 1; i >= 0; i--) {
                var seat = table.children('.seat.top')[i];
                var leftPosition = emptyDistWidthTop + ( (i) * (widthSeat + emptyDistWidthTop) );
                $(seat).css({ "left": leftPosition + "px"});
            }

            // init top position for left-seats
            for (var i = table.children('.seat.left').length - 1; i >= 0; i--) {
                var seat = table.children('.seat.left')[i];
                var topPosition = emptyDistWidthLeft + ( (i) * (widthSeat + emptyDistWidthLeft) );
                $(seat).css({ "top": topPosition + "px"});
            }

            // init top position for right-seats
            for (var i = table.children('.seat.right').length - 1; i >= 0; i--) {
                var seat = table.children('.seat.right')[i];
                var topPosition = emptyDistWidthRight + ( (i) * (widthSeat + emptyDistWidthRight) );
                $(seat).css({ "top": topPosition + "px"});
            }
            return false;
        }

        function RemoveSeat(table, sideClass) {
            var seatsEmpty = table.children('.seat.empty.' + sideClass);
            if (seatsEmpty.length == 0) {
                var seats = table.children('.seat.' + sideClass);
                // remove not empty seat
                var seatToRemove = $(seats[seats.length - 1]);
                $('#guest-list').append(seatToRemove.children().css({"margin-left": "0"}));
                seatToRemove.remove();
            } else {
                // remove empty seat
                $(seatsEmpty[seatsEmpty.length - 1]).remove();
            }
            if (sideClass == 'round') {
                RoundTableSeatsPosition(table);
            } else {
                SquareTableSeatsPosition(table);
            }
            return false;
        }

        function AddSeat(table, sideClass, guest) {
            var index = table.children('.seat').length;
            table.append('<div class = "seat empty ' + sideClass + ' dont-rotate" side="' + sideClass + '" type="empty"></div>');

            var newSeat = $(table.children('.seat')[index]);

            if (guest != undefined && guest.guest_type != undefined) {

                guestData = $("[guest_id=" + guest.guest_id + "]");

                if (guestData.length > 0) {
                    newSeat.removeClass('empty');
                    newSeat.addClass(guest.guest_type);
                    newSeat.attr('type', guest.guest_type);
                    newSeat.append(guestData);

                    CenterGuestName($(newSeat.children()));

                    $($(newSeat.children())).draggable(guestDraggableParams);
                }
            }

            newSeat.droppable(seatDroppableParams);
            RotateSeat(newSeat);

            return false;
        }

        function RemoveTable(table) {
            $.each(table.children('.seat'), function () {
                $('#guest-list').append($(this).children().css({"margin-left": "0"}));
            });
            table.remove();
            return false;
        }

        function dataToSave() {
            var tables = [];

            $.each($('.table'), function () {
                var table = $(this);
                var seatsData = [];

                $.each(table.children('.seat'), function () {
                    var seat = $(this);
                    var seatResult = {
                        "seat_type": seat.attr("type"),
                        "seat_side": seat.attr("side"),
                        "guest_id": seat.children().attr("guest_id"),
                        "guest_type": seat.children().attr("type"),
                    }
                    seatsData.push(seatResult);
                });

                var tableResult = {
                    "table_id": table.attr("table_id"),
                    "table_type": table.attr("type"),
                    "deg": table.attr("deg"),
                    "top_position": table.css("top"),
                    "left_position": table.css("left"),
                    "height": table.css("height"),
                    "width": table.css("width"),
                    "title": table.children('.title').text(),
                    "seats": seatsData,
                }
                tables.push(tableResult);
            });
            return tables;
        }

        function EditTitle(title) {
            var newTitle = prompt('Введите новое название для данного стола', title.text());
            if (newTitle) {
                title.text(newTitle);
            }
            return false;
        }

        function GetTitle() {
            var title = prompt('Введите новое название для данного стола', ('Стол №' + ( $('.table').length + 1 ) ));
            if (title) {
                return title;
            } else {
                return false;
            }
        }

        function CenterGuestName(guest) {
            var guestWidth = $(guest).width();
            var guestHeight = $(guest).height();
            guest.css({"margin-top": "-" + (guestHeight - 30) / 2 + "px"});
            guest.css({"margin-left": "-" + (guestWidth - 30) / 2 + "px"});
        }

        function MinWidthSquareTable(table) {
            var tableMinWidth = 100;
            var tableMinWidthTop = ( $(table).children('.seat.top').length ) * 60;
            var tableMinWidthBottom = ( $(table).children('.seat.bottom').length ) * 60;
            tableMinWidth = Math.max(100, tableMinWidthTop, tableMinWidthBottom);
            $(table).css({"min-width": tableMinWidth + "px"});
        }

        function MinHeightSquareTable(table) {
            var tableMinHeight = 100;
            var tableMinHeightTop = ( $(table).children('.seat.left').length ) * 60;
            var tableMinHeightBottom = ( $(table).children('.seat.right').length ) * 60;
            tableMinHeight = Math.max(100, tableMinHeightTop, tableMinHeightBottom);
            $(table).css({"min-height": tableMinHeight + "px"});
        }

        function RotateTable(table) {
            var deg = +table.attr('deg') || 0;
            var inverseDeg = 360 - deg;

            var browser_prefixes = ['-webkit', '-moz', '-o', '-ms', ''];
            for (var i = 0, l = browser_prefixes.length; i < l; i++) {
                var pfx = browser_prefixes[i];
                table.css(pfx + '-transform', 'rotate(' + deg + 'deg)');
                table.children('.dont-rotate').css(pfx + '-transform', 'rotate(' + inverseDeg + 'deg)');
            }
        }

        function RotateSeat(seat) {
            var deg = +$(seat.parent()).attr('deg') || 0;
            var inverseDeg = 360 - deg;

            var browser_prefixes = ['-webkit', '-moz', '-o', '-ms', ''];
            for (var i = 0, l = browser_prefixes.length; i < l; i++) {
                var pfx = browser_prefixes[i];
                seat.css(pfx + '-transform', 'rotate(' + inverseDeg + 'deg)');
            }
        }

        function AddTable(tableParams) {
            var table_type = tableParams.table_type || "square";
            var deg = tableParams.deg || 0;
            var topPosition = tableParams.top_position || "50px";
            var leftPosition = tableParams.left_position || "509px";
            var height = tableParams.height || "100px";
            var width = tableParams.width || "100px";
            var title = tableParams.title || "Стол";
            var seats = tableParams.seats

            if (table_type == "square") {
                addIconsData = '<div class="seating-icon left seats-count-inc dont-rotate", title="Добавить один стул на эту сторону стола"></div>\
        <div class="seating-icon left seats-count-dec dont-rotate", title="Убрать один стул с этой стороны стола"></div>\
        <div class="seating-icon top seats-count-dec dont-rotate" title="Убрать один стул с этой стороны стола"></div>\
        <div class="seating-icon top seats-count-inc dont-rotate" title="Добавить один стул на эту сторону стола"></div>\
        <div class="seating-icon right seats-count-inc dont-rotate" title="Добавить один стул на эту сторону стола"></div>\
        <div class="seating-icon right seats-count-dec dont-rotate" title="Убрать один стул с этой стороны стола"></div>\
        <div class="seating-icon bottom seats-count-dec dont-rotate" title="Убрать один стул с этой стороны стола"></div>\
        <div class="seating-icon bottom seats-count-inc dont-rotate" title="Добавить один стул на эту сторону стола"></div>'
            } else {
                addIconsData = '<div class="seating-icon round seats-count-dec" title="Убрать один стул"></div>\
        <div class="seating-icon round seats-count-inc" title="Добавить один стул"></div>'
            }

            var tableData = '\
      <div class ="table ' + table_type + ' ui-draggable" style="left: ' + leftPosition + '; top: ' + topPosition + '; width: ' + width + '; height: ' + height + ';" deg="' + deg + '" type="' + table_type + '">\
        <div class="title dont-rotate">' + title + '</div>\
        <div class="seating-icon delete dont-rotate" title="Удалить этот стол"></div>\
        ' + addIconsData + '\
        <div class="seating-icon edit dont-rotate" title="Изменить настройки стола"></div>\
        <div class="table-inv dont-rotate">\
        <div class="seating-icon rotate-handle bottom right dont-rotate" title="Повернуть стол по часвой стрелке"></div>\
        <div class="seating-icon rotate-handle bottom left dont-rotate" title="Повернуть стол против часовой стрелки"></div>\
      </div>';

            var index = $('.table').length;
            $('#chart').append(tableData);
            var table = $($('.table')[index]);

            if (table_type == "square") {
                if (seats == undefined) {
                    AddSeat(table, 'top');
                    AddSeat(table, 'bottom');
                    AddSeat(table, 'left');
                    AddSeat(table, 'right');
                } else {
                    $.each(seats, function () {
                        AddSeat(table, this.seat_side, this);
                    })
                }
                SquareTableSeatsPosition(table);
            } else {
                if (seats == undefined) {
                    AddSeat(table, 'round');
                    AddSeat(table, 'round');
                    AddSeat(table, 'round');
                } else {
                    $.each(seats, function () {
                        AddSeat(table, this.seat_side, this);
                    })
                }
                RoundTableSeatsPosition(table);
            }

            if (tableParams.top_position == undefined || tableParams.left_position == undefined) {
                var topPosition = $('#chart-max').offset().top + 150;
                var leftPosition = $('#chart-max').offset().left + 250;
                table.offset({top: topPosition, left: leftPosition});
            }

            CenterTableTitle(table);
            RotateTable(table);

            $(table).draggable(tableDraggableParams);
            $(table).resizable(tableResizableParams);
        }

        function ZoomChart() {
            var tablesLeftPositions = [];
            var tablesRightPositions = [];
            var tablesTopPositions = [];
            var tablesBottomPositions = [];

            $.each($('.print .table'), function () {
                var table = $(this);
                tablesLeftPositions.push(table.position().left);
                tablesRightPositions.push(table.position().left + Math.max(table.height(), table.width()));
                tablesTopPositions.push(table.position().top);
                tablesBottomPositions.push(table.position().top + Math.max(table.height(), table.width()));
            });

            var offsetRightX = Math.max.apply(null, tablesRightPositions);
            var offsetLeftX = Math.min.apply(null, tablesLeftPositions) - 60;

            var offsetBottomY = Math.max.apply(null, tablesBottomPositions);
            var offsetTopY = Math.min.apply(null, tablesTopPositions) - 60;

            var zoom = Math.min($('#chart-max').width() / (offsetRightX - offsetLeftX + 60), $('#chart-max').height() / (offsetBottomY - offsetTopY + 60));

            $('#chart').css({"zoom": zoom, "margin-left": "-" + offsetLeftX + "px", "margin-top": "-" + offsetTopY + "px"});
        }

        function TablesAndGuests() {
            $.each($('.print .table'), function () {
                var table = $(this);

                var guests = table.children('.seat').children('.guest').children('.name');
                var guestsData = '';
                if (guests.length > 0) {
                    $.each(guests, function () {
                        var guest = this.innerHTML;
                        guestsData += '<li>' + guest + '</li>';
                    });
                }
                ;

                var tableData = '\
          <div class="table"><h4>' + table.children('.title').text() + '</h4>\
          <ul>' + guestsData + '</ul></div>';

                $('#tables-and-guests').append(tableData);
            });
        }

        function InitTables() {
            $.get(window.location.protocol + '//' + window.location.hostname + ':' + window.location.port + '/seating_plans/' + $('#chart').attr('seating_plan_id') + '/get_tables',
                {},
                function (data, textStatus) {
                    if (data.tables != undefined) {

                        tables = $.parseJSON(data.tables);

                        $.each(tables, function () {
                            AddTable(this);
                        })

                        if ($('.print #chart').length > 0) {
                            ZoomChart();
                            TablesAndGuests();

                            $('.seat').droppable('destroy');
                            $('#chart .table.ui-draggable').draggable('destroy');
                            $('#chart .table').resizable('destroy');
                            $('#guest-list.ui-droppable').droppable('destroy');
                            $('.guest.ui-draggable').draggable('destroy');
                        }
                    }
                }
            );
        }

        // init tables
        InitTables();
        // end init tables

        $(document).on("click", ".save", function () {
            var data = dataToSave();
            $.post(window.location.protocol + '//' + window.location.hostname + ':' + window.location.port + '/seating_plans/' + $('#chart').attr('seating_plan_id') + '/save_tables',
                {
                    seating_plan_id: $('#chart').attr("seating_plan_id"),
                    tables: JSON.stringify(data),
                },
                function (data, textStatus) {
                    if (data.result == 'saved') {
                        alert('Данные успешно сохранены');
                    } else {
                        alert('Во время сохранения произошел сбой, пожалуйста повторите сохранение данных');
                    }
                }
            );
        });

        $(document).on("click", ".edit", function () {
            var table = $(this).parent();
            var title = $(table).children('.title');
            EditTitle(title);
            CenterTableTitle(table);
        });

        $(document).on("click", ".zoom-inc", function () {
            var chart = $('#chart');
            var zoom = +chart.css("zoom") || 1;
            zoom += 0.1;
            if (zoom > 1) {
                zoom = 1;
                $('.zoom-inc').hide();
            }
            if (zoom != 1) {
                $('.zoom-reset').show();
            } else {
                $('.zoom-reset').hide();
            }
            $('.zoom-dec').show();
            chart.css({"zoom": zoom});
            return false;
        });

        $(document).on("click", ".zoom-dec", function () {
            var chart = $('#chart');
            var zoom = +chart.css("zoom") || 1;
            zoom -= 0.1;
            if (zoom < 0.3) {
                zoom = 0.3;
                $('.zoom-dec').hide();
            }
            if (zoom != 1) {
                $('.zoom-reset').show();
            } else {
                $('.zoom-reset').hide();
            }
            $('.zoom-inc').show();
            chart.css({"zoom": zoom});
            return false;
        });

        $(document).on("click", ".zoom-reset", function () {
            var chart = $('#chart');
            chart.css({"zoom": "1"});
            $('.zoom-reset, .zoom-inc').hide();
            $('.zoom-dec').show();

            return false;
        });

        $(document).on("click", ".table .delete", function () {
            var table = $(this).parent();
            if (confirm("Удалить " + table.children('.title').text())) {
                RemoveTable(table);
            }
            return false;
        });

        $(document).on("click", ".add-square-table", function () {
            var title = GetTitle();
            if (title != false) {
                AddTable({"title": title, "table_type": "square"})
            }
            ;
        });

        $(document).on("click", ".add-round-table", function () {
            var title = GetTitle();
            if (title != false) {
                AddTable({"title": title, "table_type": "round"})
            }
            ;
        });

        $(document).on("click", ".rotate-handle.right", function () {
            var table = $(this).parent().parent();
            var deg = +table.attr('deg');
            deg -= 15;
            var inverseDeg = 360 - deg;

            while (deg >= 360) {
                deg -= 360;
            }

            while (deg <= -360) {
                deg += 360;
            }

            table.attr('deg', deg);

            var browser_prefixes = ['-webkit', '-moz', '-o', '-ms', ''];
            for (var i = 0, l = browser_prefixes.length; i < l; i++) {
                var pfx = browser_prefixes[i];
                table.css(pfx + '-transform', 'rotate(' + deg + 'deg)');
                table.children('.dont-rotate').css(pfx + '-transform', 'rotate(' + inverseDeg + 'deg)');
            }
        });

        $(document).on("click", ".rotate-handle.left", function () {
            var table = $(this).parent().parent();
            var deg = +table.attr('deg');
            deg += 15;
            var inverseDeg = 360 - deg;

            while (deg >= 360) {
                deg -= 360;
            }

            while (deg <= -360) {
                deg += 360;
            }

            table.attr('deg', deg);

            var browser_prefixes = ['-webkit', '-moz', '-o', '-ms', ''];
            for (var i = 0, l = browser_prefixes.length; i < l; i++) {
                var pfx = browser_prefixes[i];
                table.css(pfx + '-transform', 'rotate(' + deg + 'deg)');
                table.children('.dont-rotate').css(pfx + '-transform', 'rotate(' + inverseDeg + 'deg)');
            }
        });

        $(document).on("click", ".round.seats-count-dec", function () {
            var table = $(this).parent();
            RemoveSeat(table, 'round');
            return false;
        });

        $(document).on("click", ".top.seats-count-dec", function () {
            var table = $(this).parent();
            RemoveSeat(table, 'top');
            MinWidthSquareTable(table);
            SquareTableSeatsPosition(table);
            return false;
        });

        $(document).on("click", ".bottom.seats-count-dec", function () {
            var table = $(this).parent();
            RemoveSeat(table, 'bottom');
            MinWidthSquareTable(table);
            SquareTableSeatsPosition(table);
            return false;
        });

        $(document).on("click", ".left.seats-count-dec", function () {
            var table = $(this).parent();
            RemoveSeat(table, 'left');
            MinHeightSquareTable(table);
            SquareTableSeatsPosition(table);
            return false;
        });

        $(document).on("click", ".right.seats-count-dec", function () {
            var table = $(this).parent();
            RemoveSeat(table, 'right');
            MinHeightSquareTable(table);
            SquareTableSeatsPosition(table);
            return false;
        });

        $(document).on("click", ".round.seats-count-inc", function () {
            var table = $(this).parent();
            AddSeat(table, 'round');
            RoundTableSeatsPosition(table);
            return false;
        });

        $(document).on("click", ".top.seats-count-inc", function () {
            var table = $(this).parent();
            AddSeat(table, 'top');
            MinWidthSquareTable(table);
            SquareTableSeatsPosition(table);
            return false;
        });

        $(document).on("click", ".bottom.seats-count-inc", function () {
            var table = $(this).parent();
            AddSeat(table, 'bottom');
            MinWidthSquareTable(table);
            SquareTableSeatsPosition(table);
            return false;
        });

        $(document).on("click", ".left.seats-count-inc", function () {
            var table = $(this).parent();
            AddSeat(table, 'left');
            MinHeightSquareTable(table);
            SquareTableSeatsPosition(table);
            return false;
        });

        $(document).on("click", ".right.seats-count-inc", function () {
            var table = $(this).parent();
            AddSeat(table, 'right');
            MinHeightSquareTable(table);
            SquareTableSeatsPosition(table);
            return false;
        });
    }
});