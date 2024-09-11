Shader "Unlit/healthbar"
{
    Properties
    {
        [NoScaleOffset] _MainTex ("Texture", 2D) = "white" {}
        _ColorA ("Color A", Color) = (0,0,0,0)
        _ColorB ("Color B", Color) = (1,1,1,1)
        _Health ("Health", Range(0, 1)) = 0.87
        _Frequency ("Frequency", Range(0, 7)) = 5
        _Amplitude ("Amplitude", Range (0, 0.9)) = 0.5
        _BorderWidth ("Border Width", Range(0, 0.3)) = 0.14
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent"}
                
        LOD 100

        Pass
        {
            Cull Back
            ZWrite On
            Blend SrcAlpha OneMinusSrcAlpha // alpha blending

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
            float4 _ColorA;
            float4 _ColorB;
            float _Health;
            float _HealthBarMask;
            float mask;
            float3 healthTex;
            float _Amplitude;
            float _Frequency;
            float _BorderWidth;

            float InverseLerp(float a, float b, float value)
			{
				return saturate((value - a) / (b - a));
			}

            float4 frag (v2f i) : SV_Target
            {   
                float2 coords = i.uv;
                coords.x *= 8;

               // return float4 (frac(coords),0,1);

                float2 pointOnLineSeg = float2( clamp( coords.x, 0.5, 7.5), 0.5);
                float sdf = distance(coords, pointOnLineSeg) * 2 - 1;
                clip(-sdf);
                
               // return float4(sdf.xxx, 1);

                float bordersdf = sdf + _BorderWidth;
                float pb = fwidth(bordersdf);
               // pb = length(float2(ddx(bordersdf), ddy(bordersdf)));
                float borderMask = 1 - saturate( bordersdf / pb);
               // return float4(borderMask.xxx, 1);
               // return float4(sdf.xxx * 2, 1);
                

                _HealthBarMask = _Health > i.uv.x;
                

            //  clip(_HealthBarMask - 0.1);
                healthTex = tex2D(_MainTex, float2(_Health, i.uv.y));

                if(_Health <= 0.35){
                      float flash = cos(_Time.y * _Frequency) * _Amplitude + 1.08;
                      healthTex *= flash;
                }
            //  mask = tex2D(_MainTex, i.uv);
            //  float3 thealthColor = InverseLerp(0.2, 0.8, _Health);
            //  float3 healthbarColor = lerp(_ColorA, _ColorB, thealthColor);
            //  float3 bgColor = (0,0,0);
            //  float3 outColor = lerp(bgColor, healthbarColor, _HealthBarMask);
            //  if(mask < 0.2)
            //      discard;

                return float4(healthTex * _HealthBarMask * borderMask, 1);
            }
            ENDCG
        }
    }
}
