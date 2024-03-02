package game.controls
{
    import classes.ui.BoxCheck;
    import classes.ui.Text;
    import com.flashfla.utils.NumberUtil;
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import game.GameOptions;

    public class RawGoods extends GameControl
    {
        private var options:GameOptions;
        private var colors:Number;
        private var field:TextField;
        public var lastText:String;

        public function RawGoods(options:GameOptions, parent:DisplayObjectContainer)
        {
            if (parent)
                parent.addChild(this);

            this.options = options;

            // Copy Raw Goods Colors
            colors = options.rawGoodsColor;

            field = new TextField();
            field.defaultTextFormat = new TextFormat(Fonts.BASE_FONT_CJK, 30, colors, true);
            field.antiAliasType = AntiAliasType.ADVANCED;
            field.embedFonts = true;
            field.selectable = false;
            field.autoSize = TextFieldAutoSize.LEFT;
            field.x = 0;
            field.y = 0;
            field.text = "0.0";
            addChild(field);

            lastText = field.text;
        }

        public function update(raw_goods:Number):void
        {
            field.text = NumberUtil.numberFormat(raw_goods, 1, true).toString();
            lastText = field.text;
        }

        public function updateFromPA(good:int, average:int, miss:int, boo:int):void
        {
            field.text = NumberUtil.numberFormat(good + (average * 1.8) + (miss * 2.4) + (boo * 0.2), 1, true).toString();
            lastText = field.text;
        }

        public function set alignment(value:String):void
        {
            field.htmlText = "";
            field.autoSize = TextFieldAutoSize.NONE;
            field.x = field.y = field.width = 0;

            field.autoSize = value;
            field.htmlText = lastText;
        }

        override public function getEditorInterface():GameControlEditor
        {
            var self:RawGoods = this;

            var out:GameControlEditor = super.getEditorInterface();

            new Text(out, 10, out.cy, _lang.string("editor_component_alignment"));
            out.cy += 24;

            var checkAlignLeft:BoxCheck = new BoxCheck(out, 10 + 3, out.cy + 3, e_changeHandler);
            checkAlignLeft.checked = (field.autoSize == "left");
            new Text(out, 30, out.cy, _lang.string("editor_component_left"));
            out.cy += 22;

            var checkAlignCenter:BoxCheck = new BoxCheck(out, 10 + 3, out.cy + 3, e_changeHandler);
            checkAlignCenter.checked = (field.autoSize == "center");
            new Text(out, 30, out.cy, _lang.string("editor_component_center"));
            out.cy += 22;

            var checkAlignRight:BoxCheck = new BoxCheck(out, 10 + 3, out.cy + 3, e_changeHandler);
            checkAlignRight.checked = (field.autoSize == "right");
            new Text(out, 30, out.cy, _lang.string("editor_component_right"));
            out.cy += 22;

            function e_changeHandler(e:Event):void
            {
                if (e.target == checkAlignLeft)
                {
                    checkAlignLeft.checked = true;
                    checkAlignCenter.checked = checkAlignRight.checked = false;
                    editorLayout["alignment"] = "left";
                    self.alignment = editorLayout["alignment"];
                }
                if (e.target == checkAlignCenter)
                {
                    checkAlignCenter.checked = true;
                    checkAlignLeft.checked = checkAlignRight.checked = false;
                    editorLayout["alignment"] = "center";
                    self.alignment = editorLayout["alignment"];
                }
                if (e.target == checkAlignRight)
                {
                    checkAlignRight.checked = true;
                    checkAlignLeft.checked = checkAlignCenter.checked = false;
                    editorLayout["alignment"] = "right";
                    self.alignment = editorLayout["alignment"];
                }
            }

            return out;
        }

        override public function get id():String
        {
            return GameLayoutManager.LAYOUT_RAWGOODS;
        }
    }
}
