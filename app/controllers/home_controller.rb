class HomeController < ApplicationController
  def show
    @user=User.new
    @users_by_reviews = @user.users_most_reviews
    if user_signed_in?
      user=User.find_by_id(current_user.id)
      # Crea usuario no administrador pendiente de aprobación para un grupo existente
      if user.group_id != 0 && user.group_id != nil
        group_user = GroupUser.new
        group_user.group_id = user.group_id
        group_user.group_user_state_id=2
        group_user.user_id=user.id
        group_user.is_admin=0
        if group_user.save
          user.group_id=nil
          user.save
        end
      end
      # Crea usuario administrador aprobado para un grupo pendiente de aprobación.
      if user.requested_group_name != '' && user.requested_group_name != nil
        group = Group.new
        group.name = user.requested_group_name
        group.description = user.requested_group_name
        group.email = user.email
        group.link = ''
        group.group_state_id=2
        if group.save
          group_user2 = GroupUser.new
          group_user2.user_id = user.id
          group_user2.group_id=group.id
          group_user2.group_user_state_id=1
          group_user2.is_admin=1
          group_user2.save
          user.requested_group_name=''
          user.save
        end
      end
    end
  end

  def send_message
  	@message = Message.new(message_params)
  	ContactMailer.contact_us(@message).deliver

  	respond_to do |format|
  		format.js
  	end
  end

  def active_species
    val_sp_ids = [1,8,5094,52,53,56,67,87,5072,104,105,122,141,153,154,159,162,166,5069,5155,170,171,5156,5158,180,182,5070,185,186,187,188,200,213,218,230,5175,5176,239,240,243,375,378,5208,5209,384,385,386,394,5216,5220,401,403,414,422,423,424,429,5225,5233,5235,5236,460,5239,470,5240,498,5247,514,535,5254,552,570,577,578,579,5275,621,624,5278,644,645,648,681,684,685,5290,5291,707,729,732,736,739,740,741,744,748,5302,749,757,5321,5322,784,785,5082,5328,5329,5331,5333,823,857,858,874,5353,875,5090,895,896,897,919,920,926,931,932,933,948,950,976,981,982,983,985,5384,5385,1016,1017,1018,1019,1023,1029,1033,1034,1037,1038,1039,1040,1051,1053,1055,1065,1066,1067,1079,5077,1103,1110,1111,1166,1174,5074,1179,1187,1191,1201,5443,1209,1225,1230,5455,5456,1302,1303,1304,5490,5504,1379,1386,1424,1431,1433,1441,1455,1462,1483,1536,5580,5583,1589,5596,1600,5611,5613,5075,1632,1633,5615,1634,5617,1684,5641,1739,5653,1798,1799,1833,1841,1842,1898,1909,1934,1935,1936,5719,1976,1982,1983,1992,2011,2012,2033,5747,5748,2094,5076,2117,5822,5825,2218,5851,2239,5858,2262,2263,5864,2282,2284,2285,2303,2314,5879,2320,2322,2345,2346,5915,2427,5078,2431,5939,2483,2500,5963,5964,2528,2529,2530,5965,2538,2549,5970,2552,2553,2554,2555,5977,2559,5978,2585,5990,5991,5998,2634,2635,2636,2677,2690,2692,6842,2717,6850,6851,6853,6028,6857,6858,6859,6864,6029,6867,6870,6030,2745,6045,2769,2774,2777,6062,2786,2792,2799,2809,2929,2942,2954,2965,2966,2988,3004,3046,3050,3062,6181,6183,3087,3137,3138,5071,3158,3174,3176,6215,6217,3183,3205,3208,6232,3231,3246,6247,3264,6249,3325,6281,6282,6300,3429,3472,3526,3550,3638,5085,3662,6382,5080,3694,6392,6394,6395,6402,6415,3761,5084,3776,6422,5086,3790,6430,6431,6432,3843,6445,3878,3905,6466,6467,3921,3924,5087,3945,6478,6479,6480,4028,4049,4063,4070,4076,4091,4129,6537,4131,4133,4134,4136,4138,4162,4189,6555,4235,6569,4238,4239,5088,4260,4263,4286,4297,4363,6613,4409,6660,4524,5079,4594,4617,4624,6722,4645,4659,4664,4675,4686,6739,4751,4768,4787,6755,4810,4811,6780,4878,4885,6790,5083,6804,4960,4983,4984,4997,5032,6871,6872,6873,6891,6874,6875,6876,6877,6879,6880,6882,6883,6887,6888,6889]
    @species = Species.where(:id => val_sp_ids)
  end

  private

    def message_params
      params.require(:message).permit(:name, :email, :subject, :content)
    end

end
