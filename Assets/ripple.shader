Shader "Unlit/offset"
{
    Properties
    {
        _ColorA ("Color A", Color) = (1,1,1,1)
        _ColorB ("Color B", Color) = (1,1,1,1)
       
    }
    SubShader
    {
        Tags { "RenderType" = "Opique"
               "Queue" = "Geometry" }

        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float GetWave(float2 uv)
            {
                float2 uvCenter = uv * 2 - 1;
                float radialDistance = length(uvCenter);

                float wave = cos((radialDistance - _Time.y * 0.1) * 6.28 * 5) * 0.5 + 0.5;
                wave *= 1 - radialDistance;
                return wave;
            }

            v2f vert (appdata v)
            {
                v2f o;

           //     float wave = cos((v.uv.y + _Time.y * 0.1) * 6.28 * 5);
           //     float wave2 = cos((v.uv.x + _Time.y * 0.1) * 6.28 * 5);
           //     v.vertex.z = wave * wave2 * 0.0025;
                v.vertex.z = GetWave(v.uv) * 0.0025;
                    
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.uv = v.uv;
                return o;
            }

    
            
            float4 _ColorA;
            float4 _ColorB;

            fixed4 frag (v2f i) : SV_Target
            {
                return GetWave(i.uv);   
            }
            ENDCG
        }
    }
}
