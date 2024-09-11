Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        _ColorA ("Color A", Color) = (1,1,1,1)
        _ColorB ("Color B", Color) = (1,1,1,1)
       
    }
    SubShader
    {
        Tags { "RenderType" = "Transparent"
               "Queue" = "Transparent" }

        LOD 100

        Pass
        {
            Blend One One
            ZWrite Off
            ZTest Less
            Cull Off

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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.uv = v.uv;
                return o;
            }

            float4 _ColorA;
            float4 _ColorB;

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                float xOffset = cos(i.uv.x * 6.28 * 8) * 0.01;
                float t = cos((i.uv.y + xOffset + _Time.y * 0.8) * 6.28 * 5) * 0.5 + 0.5;
                t *= i.uv.y;

                float bottomRemover = (abs(i.normal.y) < 0.9999);
                float wave = t * bottomRemover;
                float4 gradient = lerp(_ColorA, _ColorB, i.uv.y);
                return gradient * t;       
            }
            ENDCG
        }
    }
}
