classdef Aircraft < matlab.mixin.SetGet
    properties
        pos
        att
        origVerts
        faces
        col
        pat
        ani
        vLine
    end

    methods
        function obj = Aircraft(modelName, scale, col)
            % コンストラクタ
            obj.pos = [0;0;0];
            obj.att = [0;0;0];
            obj.col = col;

            % パッチデータ読み込み
            switch modelName
                case "origami_airplane"
                    [obj.origVerts, obj.faces] = origami_airplane(scale);
                case "A1200"
                    ;
                otherwise
                    [obj.origVerts, obj.faces] = origami_airplane(scale);
            end



            % obj.Property1 = inputArg1 + inputArg2;
        end
    end

    methods (Access = public)
        function update(obj)
            % 回転行列の作成
            R = obj.createRotationMatrix();
            
            % 同次変換行列の作成
            H = R;
            H(4,4) = 1;
            H(1:3, 4) = obj.pos(:);

            % パッチの移動
            verts = obj.origVerts;
            verts(:,4) = 1;
            newVerts = (H * verts')';

            % パッチデータの更新
            obj.pat.Vertices = newVerts(:,1:3);

            % 軌跡の更新
            addpoints(obj.ani,obj.pos(1),obj.pos(2),obj.pos(3));

            % 垂線の更新
            % obj.vLine.XData = obj.pos(1)*[1 1];
            % obj.vLine.YData = obj.pos(2)*[1 1];
            % obj.vLine.ZData = obj.pos(3)*[0 1];
            
        end

        function obj = createPatch(obj)
            % パッチオブジェクトを作成
            obj.pat = patch("Vertices", obj.origVerts, "Faces", obj.faces, "FaceColor", obj.col);

            % 軌跡の作成
            obj.ani = animatedline("MaximumNumPoints",20,"Color",obj.col);

            % 垂線
            % obj.vLine = plot3(obj.pos(1)*[1 1], obj.pos(2)*[1 1], obj.pos(3)*[0 1], '-k');
            
            % 更新
            obj.update();
        end
    end

    methods (Access = private)
        function R = createRotationMatrix(obj)
            phi = obj.att(1);
            theta = obj.att(2);
            psi = obj.att(3);

            Rx = [1, 0, 0;
                  0, cos(phi), -sin(phi);
                  0, sin(phi), cos(phi)];

            Ry = [cos(theta), 0, sin(theta);
                  0, 1, 0;
                  -sin(theta),0 , cos(theta)];

            Rz = [cos(psi), -sin(psi), 0;
                  sin(psi), cos(psi), 0;
                  0, 0, 1];

            R = Rz*Ry*Rx;
        end
    end
end