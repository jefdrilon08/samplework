#!/usr/bin/env ruby

class AmortizationScheduler

  N_YEARLY = 1
  N_SEMI_ANNUALLY = 2
  N_QUARTERLY = 4
  N_MONTHLY = 2
  N_WEEKLY = 52
  N_DAILY =  365

  def self.compute_amortization_schedule(interest_rate, principal, term, mode_of_payment)
    periodic_interest = nil

    case mode_of_payment
    when "yearly"
      periodic_interest = interest_rate / N_YEARLY
    when "semi-annually"
      periodic_interest = interest_rate / N_SEMI_ANNUALLY
    when "quarterly"
      periodic_interest = interest_rate / N_QUARTERLY
    when "monthly"
      periodic_interest = interest_rate / N_MONTHLY
    when "weekly"
      periodic_interest = interest_rate / N_WEEKLY
    when "monthly"
      periodic_interest = interest_rate / N_MONTHLY
    when "daily"
      periodic_interest = interest_rate / N_DAILY
    else
      raise "invalid mode of payment"
    end

    amount_prin=principal
    no_payment=term
    iRate=(0.6/52).to_s
    iRate_cv=(iRate[1,10]).to_f #interest rate computation
    x=  (((1 + iRate_cv) ** no_payment)-1).to_f / (iRate_cv*(1+iRate_cv)**no_payment).to_f #f
    dFactor= ((x+0.0000000000001).to_s[0,16]).to_f #discount factor computation
    wPayment= (amount_prin/dFactor).round(0) #weekly payment
    total_balance= wPayment * no_payment #pag compute ng total balance
    total_interest= total_balance-amount_prin # pag compute ng total interest

    temp_ammortization_entries = [] #dagdag


    payments = []

   temp_ammortization_entries=[]
     no_payment.times do |t|
        tInterest=(amount_prin * iRate_cv).round(0)
        tPrincipal=wPayment-tInterest
        tBalance=amount_prin-tPrincipal
        amount_prin=tBalance
      payments << {
        amount: wPayment,
         balance:tBalance,
        principal:tPrincipal,
        interest:tInterest
      }
    
    end
    puts payments.last[:balance]
    last_payment=payments.last[:balance]
    payments=payments.reverse
   

      new_payments=[]
if last_payment > 0
      payments.each do |p|
       
        if last_payment > 0 
          p[:interest]=p[:interest]-1
          p[:principal]=p[:principal]+1
          p[:balance]=p[:balance]-last_payment
          last_payment=last_payment-1
        elsif last_payment < 0
          last_payment=last_payment*-1

        end 

      new_payments << p
      end
elsif last_payment < 0
  last_payment1=last_payment * -1
  payments.each do |p|
        if last_payment1 > 0 
          p[:interest]=p[:interest]+1
          p[:principal]=p[:principal]-1
          p[:balance]=p[:balance]-last_payment1
          last_payment1=last_payment1-1
        
        end 


      new_payments << p
      end


end      

    schedule = { 
      periodic_payment: wPayment,
      total_balance: total_balance,
      total_interest: total_interest,
      payments: payments.reverse
    }

  end

  
 
end

# TEST PARAMETERS
principal = 4400
interest_rate = 0.94
term = 25
mode_of_payment = "weekly"
schedule = AmortizationScheduler.compute_amortization_schedule(interest_rate, principal, term, mode_of_payment)

puts "Principal: #{schedule[:principal]}"
puts "Total Balance: #{schedule[:total_balance]}"
puts "Total Interest: #{schedule[:total_interest]}"
puts "Schedule:"

schedule[:payments].each do |payment|
  puts "Amount: #{payment[:amount]} Interest: #{payment[:interest]} Principal: #{payment[:principal]} "
  

end
